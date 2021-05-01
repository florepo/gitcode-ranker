const get = (url) => {
  return fetch(url).then(resp => resp.json())
}

export const API = { get };
