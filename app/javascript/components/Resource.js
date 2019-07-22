import React from "react"
import PropTypes from "prop-types"
class Resource extends React.Component {
  render () {
    if (this.props.data.title.match(new RegExp(".*", "i")) && this.props.data.approval_status == 1) {
      let id = "/resources/" + this.props.data.id + ".html"

      let description = this.props.data.description
      if (description == null) {
        description = "None"
      } else if (description.length > 150) {
        description = description.substring(0,150) + " ... "
      }

      let updated = this.props.data.updated_at.slice(0,10)

      let tags = []
      
      if (this.props.data.location != null) {
        let locations = this.props.data.location.split(",");
        for (let i = 0; i < locations.length; i++) {
          let value = locations[i];
          let label = (<div className="text label" key={"label-" + value}> {value} </div>)
          tags.push(label)
        }
      }

      for (let i = 0; i < this.props.data.types.length; i++) {
        let value = this.props.data.types[i];
        let label = (<div className="text label" key={"label-" + value}> {value} </div>)
        tags.push(label)
      }
      for (let i = 0; i < this.props.data.audiences.length; i++) {
        let value = this.props.data.audiences[i];
        let label = (<div className="text label" key={"label-" + value}> {value} </div>)
        tags.push(label)
      }
      for (let i = 0; i < this.props.data.topics.length; i++) {
        let value = this.props.data.topics[i];
        let label = (<div className="text label" key={"label-" + value}> {value} </div>)
        tags.push(label)
      }
      for (let i = 0; i < this.props.data.availabilities.length; i++) {
        let value = this.props.data.availabilities[i];
        let label = (<div className="text label" key={"label-" + value}> {value} </div>)
        tags.push(label)
      }
      for (let i = 0; i < this.props.data.client_tags.length; i++) {
        let value = this.props.data.client_tags[i];
        let label = (<div className="text label" key={"label-" + value}> {value} </div>)
        tags.push(label)
      }
      return (
        <a href={id} target="_blank" className="resource-results"><div className="row resource-container">
          <div className="resource-title text">
            <p>{this.props.data.title}</p>
            {/*<a href={this.props.data.url} className="resource-url" target="_blank">Website</a>*/}
            
          </div>
          <div className="resource-desc text">
              <p> {description}</p>
          </div>
          <div className="resource-bottom">
            <div className="resource-tags">
              {tags}
            </div>
            
          </div>
          <p className="resource-updated">Last Updated: {updated}</p>
        </div></a>
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
