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
      let tags = []
      
      if (this.props.data.location != null) {
        let locations = this.props.data.location.split(",");
        for (let i = 0; i < locations.length; i++) {
          let value = locations[i];
          let label = (<div className="text label" key={"label-" + value}> {value} </div>)
          tags.push(label)
        }
      }

      let tag_associations = [this.props.data.types, this.props.data.audiences, this.props.data.topics, this.props.data.availabilities, this.props.data.client_tags, this.props.data.innovation_stages, this.props.data.population_focuses, this.props.data.technologies, this.props.data.campuses];

      for (let i = 0; i < tag_associations.length; i++) {
        for (let j = 0; j < tag_associations[i].length; j++) {
          let value = tag_associations[i][j];
          let label = (<div className="text label" key={"label-" + value}> {value} </div>);
          tags.push(label);
        }
      }

      return (
        <a href={id} target="_blank" className="resource-results"><div className="row resource-container">
          <div className="resource-title text">
            <p>{this.props.data.title}</p>
          </div>
          <div className="resource-desc text">
              <p> {description}</p>
          </div>
          <div className="resource-bottom">
            <div className="resource-tags">
              {tags}
            </div>
            
          </div>
        </div></a>
      );
      return html;
      
    } else {
      return null
    }
    
  }
}

Resource.propTypes = {
  data: PropTypes.object
};
export default Resource
