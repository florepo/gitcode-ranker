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
      profileData: null,
    };
  }

  getProfileInfo = (profileName) => {
    this.setState({...this.state, isFetching: true, profileName: profileName});
    
    API.get(profileName)
      .then(result => {
        console.log(result)
        this.setState({...this.state, isFetching: false, profileData: result["data"]});
      }).catch(error => {
        console.log(error);
        this.setState({...this.state, isFetching: false, profileName: null});
      })
  }

  handleSearchSubmit = (input) => {
    this.getProfileInfo(input);
    this.setState({...this.state, profileName: input});
  }
  
  render() { 
    let renderElements;

    if(!!this.state.profileData){
      renderElements =
        <DisplayContainer
          data={this.state.profileData}
          profileName={this.state.profileName}
          status={this.state.isFetching}
        />
    } else if(this.state.isFetching===true) {
      renderElements = <p>Analyzing...</p>
    }

    return (
      <div className = "main">
        <SearchBar handleSubmit={this.handleSearchSubmit}/>
        {renderElements}
      </div>
    )
  }
}
 
export default MainContainer;
