import React from "react"

export function resultBottom(parent_this) {
    let result_bottom = (
        <div id="results-bottom">
          <p className="results-visible">Showing results {parent_this.state.results_visible} out of {parent_this.state.filtered_resources.length}</p>
          <div className="result-buttons">
            <button className="btn btn-outline-primary" onClick={parent_this.openMore}>Show More</button>
            <button className="btn btn-outline-primary" onClick={parent_this.openAll}>Show All</button>
          </div>
        </div>
    )

    if (parent_this.state.results_visible >= parent_this.state.filtered_resources.length) {
        result_bottom = (
        <div id="results-bottom">
            <p className="results-visible">Showing results {parent_this.state.results_visible} out of {parent_this.state.filtered_resources.length}</p>
        </div>
        )
    }
    return result_bottom;
}

export function resultHeader(parent_this, result_bottom) {
    let result_header = (
        <div className="col-12" id = "result-header">
            <h2>Results</h2>
            <p id="search-message">{parent_this.state.filtered_resources.length} results found</p>
        </div>
    )
    if (parent_this.state.filtered_resources.length == 0 || parent_this.state.resources.length == 0) {
    result_header = (
        <div className="col-12" id = "result-header">
        <h2>No results found</h2>
        <p id="search-message"> Try changing your filtering options.</p>
        </div>
    )
        result_bottom = <div className="row"></div>;
    }
    return [result_header, result_bottom];

}

export function filterRows(parent_this) {
    return  (
        <div className="filter-rows">
            {parent_this.state.all_filters.get("location")}
            {parent_this.state.all_filters.get("audiences")}
            {/* {parent_this.state.all_filters.get("topics")} */}
            {parent_this.state.all_filters.get("availabilities")}
            {parent_this.state.all_filters.get("population_focuses")}
            {/* {parent_this.state.all_filters.get("innovation_stages")} */}
            {parent_this.state.all_filters.get("client_tags")}
        </div>
    )
}

export function searchRow(parent_this) {
    return  (
        <div className="association" className="filter_row" id="search-row">
            <label className="search_bar_text">Search</label>
            <form onSubmit={parent_this.updateSearch} className="search-form">
            <input type="text" name="search" className="search_bar"></input>
            <button type="submit" id="search-button" className="btn" onClick={parent_this.updateSearch}>Search</button>
            </form>
        </div>
    )
}

export function filterCol(parent_this, search_row, filter_rows) {
    return (
        <div id="filter-column">
            {search_row}

            <div id="filter-directions">
              <p>Use filters to narrow down results.<br/> Click “Clear All” to start a new search.</p>
            </div>

            <div id="filter-header">
              <button id="filter-reset-button" className="btn btn-med" onClick={parent_this.reset_filters}>
              Clear All</button>
            </div>
            <div id="initial-filters">
              {parent_this.state.all_filters.get("types")}
            </div>

            <div id="filter-more">
              <button className="btn-show-filters btn btn-med" onClick={parent_this.toggle_filters}>More Filters</button>
            </div>
            
            {filter_rows}
            
        </div>
    )
}

export function render () {
    let result_bottom = resultBottom(this);
    let resultHeader_vals = resultHeader(this, result_bottom);
    let result_header = resultHeader_vals[0];
    result_bottom = resultHeader_vals[1];
    let search_row = searchRow(this);
    let filter_rows = filterRows(this);
    return (
      <div className="index"  id="resource-container-wrapper">
        {filterCol(this, search_row, filter_rows)}
        <div id="resource-column">
          {result_header}
          {this.state.filtered_resources}
          {result_bottom}
        </div> {/*resource-column*/}
      </div> /*index*/
    );
}