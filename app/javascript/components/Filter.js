import React from "react"
import PropTypes from "prop-types"
class Filter extends React.Component {
  constructor(props) {
    super(props);
    let initial_values = new Array();
    this.props.values.forEach(value => {
      initial_values.push(
        <button className="single_checkbox gold_label label">
          {value}
        </button>
      )
    });
    console.log(initial_values);
    this.state = {
      checked: false,
      values: initial_values,
      selected: new Array()
    }
  }

  change_filter (value) {
    
  }

  render () {
    return (
      <div className="association">
        <h2>{this.props.association}</h2>
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
