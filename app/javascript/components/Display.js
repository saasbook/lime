import React from "react"
import PropTypes from "prop-types"
import Resource from './Resource.js';
import Filter from './Filter.js';

class Display extends React.Component {

  constructor(props) {
    super(props);

    console.log(this.props.resources);
    let all_filters = new Map();
    Object.keys(this.props.filters).forEach(association => {
      all_filters.set(association, <Filter key={association} association={association} values={this.props.filters[association]} filter={this.filter}></Filter>)
    });

    let initial_resources = new Array();
    this.props.resources.forEach(resource => {

      initial_resources.push(<Resource key={resource.id} data={resource}></Resource>)
    });

    this.state = {
      resources: initial_resources,
      filtered_resources: initial_resources,
      all_filters: all_filters
    }
  }
  
  filter = (association, value) => {
    console.log(association);
    console.log(value);
    let filtered_resources = new Array();
    this.state.resources.forEach(resource => {
      
      let resource_associations = resource.props.data;
      console.log(resource_associations);
      // filtered_resources.push(<Resource key={resource.id} data={resource}></Resource>)
    })
    
    this.setState({filtered_resources: filtered_resources});
  }
  

  render () {
    let result_header = (
      <div className="col-12" id = "result-header">
        <h2>Results</h2>
      </div>
    )

    if (this.state.resources.length == 0) {
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
            {this.state.all_filters.get("types")}
            {this.state.all_filters.get("audiences")}
            {this.state.all_filters.get("topics")}
            {this.state.all_filters.get("availabilities")}
          </div>
        </div> {/*filter-column*/}
        <div id="resource-column">
          {result_header}
            <div className="row" id="pages">
              <ul className="pagination">
                <li className="page-arrow prev disabled" id="prev">
                  <p id="prevLink" className="page-link prevLink">Previous</p>
                </li>
              </ul>
            </div>
            {this.state.filtered_resources}
            
            <div className="row" id="pages">
              <ul className="pagination">
                <li className="page-arrow prev disabled" id="prev">
                  <p id="prevLink" className="page-link prevLink">Previous</p>
                </li>
              </ul>
            </div>
        </div> {/*resource-column*/}
      </div> /*index*/


      
    );
  }
}

Display.propTypes = {
  filters: PropTypes.object,
  resources: PropTypes.array
};
export default Display
