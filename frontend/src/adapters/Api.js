import {BACKEND_PROFILES_URL} from '../adapters/Endpoints';

const get = (profile_name) => {
  let url = BACKEND_PROFILES_URL + "/" + profile_name

  return fetch(url).then(resp => resp.json())
}

export const API = { get };
