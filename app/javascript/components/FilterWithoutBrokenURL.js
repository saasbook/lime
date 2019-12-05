import React from "react"
import PropTypes from "prop-types"
class Filter extends React.Component {
    constructor(props) {
        super(props);

        let initial_values = this.resetInitialValues();
        this.state = {
            values: initial_values,
            selected: new Set()
        }
    }

    resetInitialValues = () => {
        let initial_values = new Array();
        this.props.values.forEach(value => {
            initial_values.push(
                <button key={value} data-key={value} className="single_checkbox gold_label label" onClick={(e) => this.change_filter(e, this.props.association, value)}>
                    {value}
                </button>
            )
        });


        var index=initial_values.indexOf("BrokenURL")
        //if (!user_signed_in) {
        initial_values.splice(index, 1);
        //}


        return initial_values;
    }

    reset = () => {
        let initial_values = this.resetInitialValues();
        $(".filters").children().each (button => {
            $(".filters").children()[button].className = "single_checkbox gold_label label";
        })
        this.setState({values: initial_values,
            selected: new Set()});
    }

    change_filter = (e, association, value) => {
        let key = e.target.getAttribute("data-key");
        let curr_selected = this.state.selected;
        if (this.props.association === "location") {
            /* special case for Location filtering */
            curr_selected = new Set([key]);
            $(".filters-loc").children().each (button => {
                $(".filters-loc").children()[button].className = "single_checkbox gold_label label";
            })

            if (this.state.selected.values().next().value == curr_selected.values().next().value) {
                this.props.filter(association, "Global");
                curr_selected.clear();
            } else {
                this.props.filter(association, value);
                e.target.className = "single_checkbox gold_label label active"
            }
            this.setState({selected: curr_selected});

        } else {
            /* change color of buttons */
            if (this.state.selected.has(key)) {
                e.target.className = "single_checkbox gold_label label"
                curr_selected.delete(key);
            } else {
                e.target.className = "single_checkbox gold_label label active"
                curr_selected.add(key);
            }
            this.setState({selected: curr_selected});

            /* call filter function in Display */
            this.props.filter(association, value);
        }
    }

    render () {
        let filter_div = (<div className="filters">{this.state.values}</div>)
        if (this.props.association === "location") {
            filter_div = (<div className="filters filters-loc">{this.state.values}</div>)
        }

        return (
            <div className="association">
                <h2>{this.props.association.charAt(0).toUpperCase() + this.props.association.slice(1).replace(/_/g, ' ')}</h2>
                {filter_div}
            </div>/*association*/
        );
    }
}

Filter.propTypes = {
    association: PropTypes.string,
    values: PropTypes.array
};
export default Filter