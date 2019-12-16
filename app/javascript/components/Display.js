import React from "react"
import PropTypes from "prop-types"
import Resource from './Resource.js';
import Filter from './Filter.js';

import { DEFAULT_ECDH_CURVE } from "tls";
import { all } from "q";
import { render, searchRow } from './helpers/Display_helper.js';

class Display extends React.Component {

  constructor(props) {
    super(props);
    this.resetRefs = new Array();
    let initial_resources = new Array();
    /* TODO: this.props.resources shouldn't have unapproved or archived resources (same with admin view) because these are visible in html */
    this.props.resources.forEach(resource => {
      initial_resources.push(<Resource key={resource.id} data={resource}></Resource>)
    });

    let all_filters = new Map();
    let filter_indices = new Map();
    let i = 0;
    Object.keys(this.props.filters).forEach(association => {
      let ref = React.createRef();
      this.resetRefs.push(ref)
      all_filters.set(association, <Filter key={association} association={association} values={this.props.filters[association]} user_signed_in={this.props.user_signed_in} filter={this.filter} ref={this.resetRefs[i]}></Filter>)
      filter_indices.set(association, i);
      i++;
    });

    /* initialze filters to include all Global resources and its children */ 
    let children_map = new Map(Object.entries(this.props.child_locations));
    let s = new Set();
    children_map.get("Global").forEach(location => {
      s.add(location);
    });
    let initial_filters = new Map();
    initial_filters.set("location", s);

    this.state = {
      resources: initial_resources,
      filtered_resources: initial_resources,
      all_filters: all_filters,
      activated_filters : initial_filters,
      filter_indices: filter_indices,
      child_locations: children_map,
      search_text: "",
      results_visible: 10
    }
    
    this.render = render.bind(this) // bind "this" to helper file's "render" function
  }

  /* remove all selected filters and clear search */
  reset_filters = () => {
    /* reset resources */ 
    let children_map = new Map(Object.entries(this.props.child_locations));
    let s = new Set();
    children_map.get("Global").forEach(location => {
      s.add(location);
    });
    let initial_filters = new Map();
    initial_filters.set("location", s);

    let done = false;
    var values = this.state.all_filters.values();
    let next = values.next();
    while(!done) {
      let filter_object = next.value;
      if (this.state.activated_filters.has(filter_object.props.association)) {
        let filter_index = this.state.filter_indices.get(filter_object.props.association);
        this.resetRefs[filter_index].current.reset();
      }
      next = values.next();
      done = next.done;
    }
    // callback needed to filter after updating state
    this.setState({activated_filters: initial_filters, search_text: ""}, () => {
      this.filter("location", "Global")
    });
    $(".search_bar")[0].value = "";
    
  }
  
  // clicking on a filter button
  filter = (association, value) => {
    let curr_activated_filters = this.state.activated_filters;
    if (association == "text") {
      this.setState({activated_filters: curr_activated_filters});
    } else if (association == "location") {
      /* for locations, its "Set" gets reset to include its value as well as all its children */
      let s = new Set();
      this.state.child_locations.get(value).forEach(location => {
        s.add(location);
      });
      curr_activated_filters.set(association, s);
    } else if (curr_activated_filters.has(association)) {
      if (curr_activated_filters.get(association).has(value)) {
      
        curr_activated_filters.get(association).delete(value);
      } else {
        curr_activated_filters.get(association).add(value);
      }
    } else {
      let s = new Set();
      s.add(value);
      curr_activated_filters.set(association, s);
    }

    this.setState({activated_filters: curr_activated_filters});

    /* reset the array filtered_resources before refiltering */
    let filtered_resources = new Array();

    /* loop and push into filtered_resources */
    this.state.resources.forEach(resource => {
      let includes = true;
      let resource_associations = resource.props.data;
      for (const [key, value] of this.state.activated_filters.entries()) {
        value.forEach(v => {
          if (key == "location") {
            let resource_location = resource_associations[key]
            if (resource_location != null) {
              /* case when there are multiple locations */
              resource_location = resource_location.split(",").map(function(item) {
                return item.trim();
              });
              if (resource_location.length === 1) {
                resource_location = resource_location[0];
              } else {
                resource_location = resource_location[1];
              }
            }
            
            if (resource_location === "United States") {
              resource_location = "USA"
            } else if (resource_location === "International") {
              resource_location = "Global"
            }
            let children_set = curr_activated_filters.get("location");
            if (!children_set.has(resource_location)){
              includes = false;
            }
            
            /* exception if no location for a resource exists. is only included in "Global" */
            if ((resource_location == undefined || resource_location.length < 1) && children_set.has("Global")) {
              includes = true;
            }
          } else {
            if (resource_associations[key] == undefined || resource_associations[key].length < 1 || !resource_associations[key].includes(v)) {
              includes = false;
            }
          }
        }); // forEach
      } // for
      if (includes) {
        filtered_resources.push(<Resource key={resource.props.data.id} data={resource.props.data}></Resource>);
      }
    }) // forEach

    /* match with the text in search field */
    filtered_resources = this.search(filtered_resources);
    
    /* 
    * update the state from these results 
    * after state updated, use callback to openInitial 10 
    */
    if (filtered_resources.length < 10) {
      this.setState({filtered_resources: filtered_resources, activated_filters: curr_activated_filters, results_visible: filtered_resources.length}, this.openInitial);
    } else {
      this.setState({filtered_resources: filtered_resources, activated_filters: curr_activated_filters, results_visible: 10}, this.openInitial);
    }
  } // filter

  // submit the search text field, use a regexp based on title, desc, url
  search = (curr_resources) => {
    let filtered_resources = new Array();
    curr_resources.forEach(resource => {
      let title = resource.props.data["title"]
      let description = resource.props.data["description"]
      let url = resource.props.data["url"]

      let search_text = this.state.search_text.split(" ");
      let regex_string = ""
      search_text.forEach(word => {
        regex_string = regex_string + "(?=.*" + word + ")";
      })
      regex_string = regex_string + ".+"
      
      let regex = new RegExp(regex_string, 'i');
      if (!filtered_resources.includes(resource) && (regex.test(title) || regex.test(url) ||  regex.test(description))) {
        filtered_resources.push(resource);
      }
      
    });
    return filtered_resources;
  }

  
  // show or hide "More Filters" when pressing the button
  toggle_filters = () => {
    let navigationHeight = $("body").height();
    let initial_filter_height = ($(window).height() - navigationHeight - 64);
    
    if ($(".filter-rows")[0].style.display ==="block") {
      let newHeight =  parseInt($("#filter-header").css("height")) + parseInt($("#initial-filters").css("height")) + parseInt($("#filter-more").css("height")) + parseInt($("#search-row").css("height")) + 32 + 32 + 8 + 32;
      $(".btn-show-filters")[0].innerHTML = "Show Filters"
      $("#filter-column").css({height: newHeight});
    } else {
      let newHeight = initial_filter_height;
      if ($(window).scrollTop() > navigationHeight) {
        newHeight = initial_filter_height + navigationHeight;
        
      } else {
        newHeight = initial_filter_height + $(window).scrollTop();
      }
      $(".btn-show-filters")[0].innerHTML = "Hide Filters"
      $("#filter-column").css({height: newHeight});
    }
    $(".filter-rows").toggle(0);
  }

  updateSearch = (e) => {
    e.preventDefault();
    this.setState({search_text: $(".search_bar")[0].value}, () => {
      this.filter("text", "search");
    });
  }


  componentDidMount() {
    if (this.state.filtered_resources.length > 0) {
      this.openInitial();
    } else {$(".pagination").html("");}
  }

  componentDidUpdate() {
  }

  unhide = (end) => {
    let count = 1;
    $(".resource-container").each(function() {
      if (count >= 1 && count <= end) {
          $(this).removeClass("hidden-resource");
      } else {
          $(this).addClass("hidden-resource");
      }
      count++;
    });
    
  }

  // Show first 10 resources, hide rest
  openInitial = () => {
    let end = 10;
    if (end > this.state.results_visible) {
      end = this.state.results_visible;
    }
    this.unhide(end);
    
  }
  
  // Organize all resources into sections of 10 (either hide or show)  
  openMore = () => {
    let end = this.state.results_visible + 10;
    if (end > this.state.filtered_resources.length) {
      end = this.state.filtered_resources.length;
    }
    this.unhide(end);

    this.setState({results_visible: end})
  }

  openAll = () => {
    let end = this.state.filtered_resources.length;
    let count = 1;
    $(".resource-container").each(function() {
      $(this).removeClass("hidden-resource");
    });
    this.setState({results_visible: end})
  }
}

Display.propTypes = {
  filters: PropTypes.object,
  child_locations: PropTypes.object,
  resources: PropTypes.array,
  user_signed_in: PropTypes.bool
};
export default Display
