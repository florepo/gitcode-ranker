import React from 'react';

import Favourites from '../components/Favourites'
import Languages from '../components/Languages'

const DisplayContainer = (props) => {
  const languages = props.data["languages"]

  const isEmpty = (obj) => {return JSON.stringify(obj) === '{}' }

  const selectedProfile = (profileName) => <p>Selected GitHub Profile: <b>{profileName}</b></p>
  const totalNumberOfRepositories = (numberOfRepos) => <p>Repositories found: <b>{numberOfRepos}</b></p>

  let renderElements

  if (!isEmpty(languages)){
    renderElements =
      <React.Fragment>
        {totalNumberOfRepositories(props.data["total_repos"])}
        <Favourites data={props.data}/>
        <Languages data={props.data}/>
      </React.Fragment>
  } else {
    renderElements = <p>No public repositories found</p>
  }

  return (
    <React.Fragment>
      {selectedProfile(props.profileName)}
      {renderElements}
    </React.Fragment>
  )
}

export default DisplayContainer;
