import React, {Component} from 'react';

import {API} from '../adapters/Api';

import SearchBar from '../components/SearchBar';
import DisplayContainer from './DisplayContainer';

class MainContainer extends Component {
  constructor(props) {
    super(props);
    this.state = {
      isFetching: false,
      profileName: null,
      profileData: {},
    };
  }

  getProfileInfo = (profileName) => {
    this.setState({isFetching: true, profileName: profileName});
    
    API.get(profileName)
      .then(result => {
        console.log(result)
        this.setState({...this.state, isFetching: false, profileData: result["data"]});
      }).catch(error => {
        console.log(error);
        this.setState({...this.state, isFetching: null, profileName: null});
      })
  }

  handleSearchSubmit = (input) => { this.getProfileInfo(input) };
  
  render() { 
    return (
      <div className = "main">
        <SearchBar handleSubmit={this.handleSearchSubmit}/>
        <DisplayContainer
          data={this.state.profileData}
          profileName={this.state.profileName}
          isLoading={this.state.isFetching}
        />
      </div>
    )
  }
}
 
export default MainContainer;
