import React from 'react';

const Favourites = (props) => {
  const favouriteLanguages = props.data["most_used_language"]
  const pluralizeLanguage = favouriteLanguages.length===1 ? "language is" : "languages are"

  return (
    <div className="favourites">
      <p> The most commonly used {pluralizeLanguage}: <b>{favouriteLanguages.join(', ')}</b></p>
    </div>
  )
}

export default Favourites;
