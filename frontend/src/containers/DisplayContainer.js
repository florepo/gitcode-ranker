import React from 'react';

import Languages from '../components/Languages';
import Spinner from '../components/Spinner';

const DisplayContainer = (props) => {
  if(props.isLoading){ return (<Spinner />) }
  if("error" in props.data) { return <p>Profile not found</p>; }

  const selectedProfile = (profileName) => {
    if (profileName) {
      return <p>Selected GitHub Profile: <b>{profileName}</b></p>;
    } else {
      return null
    }
  }

  const publicRepositoriesFound = (numberOfRepos) => {
    if (numberOfRepos>0) {
      return <p>Public Repositories found: <b>{numberOfRepos}</b></p>;
    } else {
      return <p>No public repositories found</p>;
    }
  }

  return  <React.Fragment>
    {selectedProfile(props.profileName)}
    {selectedProfile(props.profileName)? publicRepositoriesFound(props.data.total_repos) : null}
    {"languages" in props.data? <Languages data={props.data} /> : null}
  </React.Fragment>
};

export default DisplayContainer;
