import React from "react"
import PropTypes from "prop-types"
class Filter extends React.Component {
  constructor(props) {
    super(props);
    let initial_values = new Array();
    this.props.values.forEach(value => {
      initial_values.push(
        <button key={value} data-key={value} className="single_checkbox gold_label label" onClick={(e) => this.change_filter(e, this.props.association, value)}>
          {value}
        </button>
      )
    });
    this.state = {
      values: initial_values,
      selected: new Set()
    }
  }

  change_filter = (e, association, value) => {
    this.props.filter(association, value)
    let key = e.target.getAttribute("data-key");
    let curr_selected = this.state.selected;
    if (this.state.selected.has(key)) {
      e.target.className = "single_checkbox gold_label label"
      curr_selected.delete(key);
    } else {
      e.target.className = "single_checkbox gold_label label active"
      curr_selected.add(key);
    }
    this.setState({selected: curr_selected});
  }

  render () {
    return (
      <div className="association">
        <h2>{this.props.association.charAt(0).toUpperCase() + this.props.association.slice(1)}</h2>
        <div className="filters">
          {this.state.values}
        </div>
      </div>/*association*/
    );
  }
}

Filter.propTypes = {
  association: PropTypes.string,
  values: PropTypes.array
};
export default Filter
