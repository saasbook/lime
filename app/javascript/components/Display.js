import React from "react"
import PropTypes from "prop-types"
import Resource from './Resource.js';
import Filter from './Filter.js';
import { DEFAULT_ECDH_CURVE } from "tls";

class Display extends React.Component {

  constructor(props) {
    super(props);
    

    let all_filters = new Map();
    Object.keys(this.props.filters).forEach(association => {
      all_filters.set(association, <Filter key={association} association={association} values={this.props.filters[association]} filter={this.filter}></Filter>)
    });

    let initial_resources = new Array();
    this.props.resources.forEach(resource => {
      initial_resources.push(<Resource key={resource.id} data={resource}></Resource>)
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
      child_locations: children_map
    }
    
  }
  
  filter = (association, value) => {

    let curr_activated_filters = this.state.activated_filters;
    if (association == "location") {
      /* for locations, its Set gets reset to include its value as well as all its children */
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

    /* reset filtered_resources */
    let filtered_resources = new Array();
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
        });
        
      }
      if (includes) {
        filtered_resources.push(<Resource key={resource.props.data.id} data={resource.props.data}></Resource>);
      }
    })
    
    this.setState({filtered_resources: filtered_resources});
  }

  componentDidMount() {
    if (this.state.filtered_resources.length > 0) {
      this.paginate();
    } else {$(".pagination").html("");}
  }

  componentDidUpdate() {
    if (this.state.filtered_resources.length > 0) {
      this.paginate();
    } else {$(".pagination").html("");}
  }
  
  paginate = () => {
    $(".pagination").html("");
    let itemsPerPage = 10;
    let numResources = $(".resource-container").length
    let numPages = Math.ceil(numResources / itemsPerPage);

    let openPage = function(pageNum) {
        currentPage = pageNum;
        let start = ((pageNum - 1) * itemsPerPage) + 1;
        let end = (pageNum * itemsPerPage);
        let count = 1;
        $(".resource-container").each(function() {
            if (count >= start && count <= end) {
                $(this).removeClass("hidden-resource");
            } else {
                $(this).addClass("hidden-resource");
            }
            count++;
        });
    }

    let setActive = function()  {
        let count = 1;
        $(".page-item").each(function() {
            if (count === Number(currentPage)) {
                $(this).addClass("active"); 
            }
            count++;
            if (count > numPages) {
                count = 1;
            }
        });
    }

    
    $(".pagination").append('<li class="page-arrow prev disabled" id="prev"><p id="prevLink" class="page-link prevLink">Previous</p></li>');
    for (let i = 1; i <= numPages; i++) {
        $(".pagination").append('<li class="page-item"><p class="page-link">' + i + '</p></li>');
    }
    $(".pagination").append('<li class="page-arrow next disabled" id="next"><p id="nextLink" class="page-link nextLink">Next</p></li>');
    if (numPages > 1) {
        $(".next").removeClass("disabled")
    }
    /* hide all pages */
    $(".resource-container").addClass("hidden-resource");

    /* open first page */
    openPage(1);
    setActive(1);
    var currentPage = 1;

    /* pagination buttons */
    $(".page-link").click(function() {
        if($(this).hasClass("nextLink")) {
            openPage(Number(currentPage) + 1);
        } else if ($(this).hasClass("prevLink")){
            openPage(Number(currentPage) - 1);
        } else {
            openPage($(this).text());
        }
        
    });

    $(".page-item").click(function() {
        $(".page-item").removeClass("active");
        setActive();

        if (currentPage < numPages) {
            $(".next").removeClass("disabled");
        } else {
            $(".next").addClass("disabled");
        }
        if ((currentPage >= 2)) {
            $(".prev").removeClass("disabled");
        } else {
            $(".prev").addClass("disabled");
        }    
    });

    $(".page-arrow").click(function() {
        $(".page-item").removeClass("active"); 
        if ($(this).hasClass("next") && currentPage >= numPages) {
            $(".next").addClass("disabled");
            $(".prev").removeClass("disabled")
        } else if ($(this).hasClass("prev") && currentPage <= 1) {
            $(".prev").addClass("disabled");
            $(".next").removeClass("disabled")
        } else {
            $(".page-arrow").removeClass("disabled")
        }

        setActive();
    });
  }


  render () {
    let result_header = (
      <div className="col-12" id = "result-header">
        <h2>Results</h2>
      </div>
    )

    if (this.state.filtered_resources.length == 0 || this.state.resources.length == 0) {
      result_header = (
        <div className="col-12" id = "result-header">
          <h2>No results found</h2>
          <p id="none_message"> Try changing your filtering options.</p>
        </div>
      )
    }

    return (
      <div className="index"  id="resource-container-wrapper">
        <div id="filter-column">
          <div>
            <div className="row">
              <div id="filter-header">
                <button id="filter-reset-button" className="btn btn-outline-dark btn-sm">Reset Filters</button>
              </div>
            </div>{/*reset-button*/}
            <div className="association" id="search_row">
              <label className="search_bar_text">Search</label>
              <input type="text" name="search" className="search_bar"></input>
            </div>{/*search-row*/}
            {this.state.all_filters.get("location")}
            {this.state.all_filters.get("types")}
            {this.state.all_filters.get("audiences")}
            {this.state.all_filters.get("topics")}
            {this.state.all_filters.get("availabilities")}
          </div>
        </div> {/*filter-column*/}
        <div id="resource-column">
          {result_header}
            <div className="row" id="pages">
              <ul className="pagination"></ul>
            </div>
            {this.state.filtered_resources}
            
            <div className="row" id="pages">
              <ul className="pagination"></ul>
            </div>
        </div> {/*resource-column*/}
      </div> /*index*/


      
    );
  }
}

Display.propTypes = {
  filters: PropTypes.object,
  child_locations: PropTypes.object,
  resources: PropTypes.array
};
export default Display
