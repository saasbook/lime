import React from "react"

export function render () {
    let result_header = (
      <div className="col-12" id = "result-header">
        <h2>Results</h2>
        <p id="search-message">{this.state.filtered_resources.length} results found</p>
      </div>
    )

    let result_bottom = (
      <div id="results-bottom">
        <p className="results-visible">Showing results {this.state.results_visible} out of {this.state.filtered_resources.length}</p>
        <div className="result-buttons">
          <button className="btn btn-outline-primary" onClick={this.openMore}>Show More</button>
          <button className="btn btn-outline-primary" onClick={this.openAll}>Show All</button>
        </div>
      </div>
    )

    if (this.state.results_visible >= this.state.filtered_resources.length) {
      result_bottom = (
        <div id="results-bottom">
          <p className="results-visible">Showing results {this.state.results_visible} out of {this.state.filtered_resources.length}</p>
        </div>
      )
    }

    if (this.state.filtered_resources.length == 0 || this.state.resources.length == 0) {
      result_header = (
        <div className="col-12" id = "result-header">
          <h2>No results found</h2>
          <p id="search-message"> Try changing your filtering options.</p>
        </div>
      )
      result_bottom = <div className="row"></div>;
    }

    return (
      <div className="index"  id="resource-container-wrapper">
        <div id="filter-column">

            <div className="association" className="filter_row" id="search-row">
              <label className="search_bar_text">Search</label>
              <form onSubmit={this.updateSearch} className="search-form">
                <input type="text" name="search" className="search_bar"></input>
                <button type="submit" id="search-button" className="btn" onClick={this.updateSearch}>Search</button>
              </form>
            </div>{/*search-row*/}
            <div id="filter-directions">
              <p>Use filters to narrow down results.<br/> Click “Clear All” to start a new search.</p>
            </div>

            <div id="filter-header">
              <button id="filter-reset-button" className="btn btn-med" onClick={this.reset_filters}>
              Clear All</button>
            </div>
            <div id="initial-filters">
              {this.state.all_filters.get("types")}
            </div>

            <div id="filter-more">
              <button className="btn-show-filters btn btn-med" onClick={this.toggle_filters}>More Filters</button>
            </div>
            
            <div className="filter-rows">
            {this.state.all_filters.get("location")}
              {this.state.all_filters.get("audiences")}
              {/* {this.state.all_filters.get("topics")} */}
              {this.state.all_filters.get("availabilities")}
              {this.state.all_filters.get("population_focuses")}
              {/* {this.state.all_filters.get("innovation_stages")} */}
              {this.state.all_filters.get("client_tags")}
            </div>{/*filter-rows*/}
            
        </div> {/*filter-column*/}
        <div id="resource-column">
          {result_header}
          {this.state.filtered_resources}
          {result_bottom}
        </div> {/*resource-column*/}
      </div> /*index*/
    );
  }