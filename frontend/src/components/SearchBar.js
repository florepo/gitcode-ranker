
import React, {Component} from 'react';

import {Input, Button} from "semantic-ui-react";

class SearchBar extends Component {
  constructor(props) {
    super(props);
    this.state = { input: null }
  }

  handleChange = (event) => {
    this.setState({ input: event.target.value });
  }

  handleSubmit = (event) => {
    event.preventDefault();
    this.props.handleSubmit(this.state.input)
  }

  render() { 
    return ( 
      <div className="searchbar">
        <form className="search-form"
          onSubmit={this.handleSubmit}
        >
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
