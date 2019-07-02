import React from "react"
import PropTypes from "prop-types"
class Resource extends React.Component {
  render () {
    return (
      <React.Fragment>
        Title: {this.props.title}
      </React.Fragment>
    );
  }
}

Resource.propTypes = {
  title: PropTypes.string
};
export default Resource
