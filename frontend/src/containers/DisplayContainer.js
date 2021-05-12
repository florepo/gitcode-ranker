import React from 'react';

import Languages from '../components/Languages';
import Spinner from '../components/Spinner';

const DisplayContainer = (props) => {

  if(props.isLoading){ return (<Spinner />) };

  if(JSON.stringify(props.data)==='{}' || !props.data ) { return <p>Profile not found</p>; }

  if(props.data && !props.data.total_repos) { <p>No public repositories found</p>;  }

  const selectProfile = (profileName) => <p>Selected GitHub Profile: <b>{profileName}</b></p>;
  const publicReposFound = (numberOfRepos) => <p>Public Repositories found: <b>{numberOfRepos}</b></p>;
    
  let renderElements =
    <React.Fragment>
      {selectProfile(props.profileName)}
      {publicReposFound(props.data.total_repos)}
      <Languages data={props.data}/>
    </React.Fragment>

  return renderElements
};

export default DisplayContainer;
