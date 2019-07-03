import React from "react"
import PropTypes from "prop-types"
class Resource extends React.Component {
  render () {
    if (this.props.data.title.match(new RegExp(".*", "i"))) {
      let id = "/resources/" + this.props.data.id + ".html"

      let description = this.props.data.description
      if (description == null) {
        description = "None"
      } else if (description.length > 250) {
        description = description.substring(0,250) + " ... "
      }

      let location = this.props.data.location
      let location_html = ""

      let updated = this.props.data.updated_at.slice(0,10)
      if (location != null) {
        location = location.replace(",", ", ");
        location_html = <div className="resource-location text">
          <p className="title">Location:</p>
          <p> {location} </p>
        </div>
      }
      return (
        <div className="row resource-container">
          <div className="resource-title text">
            <a href={id}>{this.props.data.title}</a>
          </div>
          <div className="resource-url text">
            <p className="title">URL:</p>
            <a href={this.props.data.url} target="_blank">{this.props.data.url}</a>
          </div>
          <div className="resource-desc text">
              <p className="title">Description:</p>
              <p> {description}</p>
            
          </div>
          {location_html}
        
          <div className="text links">
            <a href={id} className="btn btn-outline-primary">More info</a>
            <p className="resource-updated">Last Updated: {updated}</p>
            
            {/* <% if user_signed_in? %>
              <%= link_to('Edit', edit_resource_path(resource), class: "btn btn-outline-primary") %>
            <% end %> */}
          </div>
        </div>
      );
    } else {
      return null
    }
    
  }
}

Resource.propTypes = {
  data: PropTypes.object
};
export default Resource
