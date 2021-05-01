
import React, {Component} from 'react';

import SearchBar from '../components/SearchBar';
import DisplayContainer from './DisplayContainer';

import {API} from '../adapters/Api';
import BACKEND_PROFILES_URL from '../adapters/Endpoints';

class MainContainer extends Component {
  constructor(props) {
    super(props);
    this.state = {
      loadingState: "ready",
      status: "ok",
      data: null,
      searchInput: null
    };
  }

  componentDidUpdate(prevProps, prevState){
    if (prevState.searchInput !== this.state.searchInput) {
      this.getProfileInfo();
    }
  }

  getProfileInfo = (profile_name) => {
    if (profile_name) {
      let url = BACKEND_PROFILES_URL + "/" + profile_name
      return API.get(url)
        .then(json => this.setState(
          {
            status: json["status"],
            data: json["data"],
            loadingState: "ready"
          }
        ))
    }
  }

  handleSearchSubmit = (profile_name_input) => {
    this.setState({ loadingState: "loading", searchInput: profile_name_input })
    setTimeout(this.getProfileInfo, 400, profile_name_input);
  }
  
  render() { 
    let hasOkStatus = Boolean(this.state.status==="ok")

    let userMessage = (status) => status ? "Enter GitHub Profile name you wish to analyse" : this.state.status

    return (
      <React.Fragment>
        <div className = "main">
          <SearchBar handleSubmit={this.handleSearchSubmit}/>
          {
            (hasOkStatus && !!this.state.searchInput)
            ? 
            <DisplayContainer
              data={this.state.data}
              status={this.state.status}
              profile_name={this.state.searchInput}
            />
            :
            userMessage(hasOkStatus)
          }
        </div>
      </React.Fragment>
    )
  }
}
 
export default MainContainer;
