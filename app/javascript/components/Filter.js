import React from "react"
import PropTypes from "prop-types"
class Filter extends React.Component {
  constructor(props) {
    super(props);
    let initial_values = new Array();
    this.props.values.forEach(value => {
      initial_values.push(
        <button key={value} className="single_checkbox gold_label label" onClick={() => this.change_filter(this.props.association, value)}>
          {value}
        </button>
      )
    });
    this.state = {
      values: initial_values,
      selected: new Array()
    }
  }

  change_filter = (association, value) => {

    this.props.filter(association, value)
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
