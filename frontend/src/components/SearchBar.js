
import React, {Component} from 'react';

import {Input, Button} from "semantic-ui-react";

class SearchBar extends Component {
  constructor(props) {
    super(props);
    this.state = { input: null }
  }

  handleChange = (ev) => {
    this.setState({ input: ev.target.value });
  }

  handleSubmit = (ev) => {
    ev.preventDefault();
    console.log(this.state.input)
    this.props.handleSubmit(this.state.input)
  }

  render() { 
    return ( 
      <div className="searchbar-container">
        <div className="search-prompt">Enter the GitHub profile name you wish to analyse</div>
        <form className="search-form" onSubmit={this.handleSubmit}>
          <Input className="form-input"
            placeholder="GitHub Profile Name"
            onChange={this.handleChange}
          />
          <Button type="submit">
            Submit
          </Button>
        </form>
      </div>
    )
  }
}
 
export default SearchBar;
