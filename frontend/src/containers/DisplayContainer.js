import React from 'react';

import Favourites from '../components/Favourites'
import Languages from '../components/Languages'

const DisplayContainer = () => {
  let mostUsedLanguage = this.props.data["most_used_language"]
  let noRepositoriesFoundMessage = "No repositories published"

  const renderResults = () => {
    if (mostUsedLanguage){
      <React.Fragment>
        <p>Selected GitHub Profile: <b>{this.props.profile_name}</b></p>
        <Favourites data={this.props.data}/>
        <Languages data={this.props.data}/>
      </React.Fragment>
    } else {
      noRepositoriesFoundMessage()
    }
  }

  return (
    <React.Fragment>
      {renderResults()}
    </React.Fragment>
  );
}

export default DisplayContainer;
