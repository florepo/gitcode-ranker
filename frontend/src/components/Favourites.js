import React from 'react';

const Favourites = () => {
  let favouriteLanguages = this.props.data["most_used_language"]
  let timesFavouriteLanguageIsUsed = this.props.data.languages[[...favouriteLanguages.shift()]]

  const languages = favouriteLanguages.length===1 ? "language is" : "languages are"
  const repositories = timesFavouriteLanguageIsUsed===1 ? "repository" : "repositories"

  return (
    <div className="favourites">
      <p> The most commonly used {languages} </p>
      {
        favouriteLanguages.map(language =>
          <div key={language}>
            <p><b>{language}</b></p>
          </div>
        )
      }
      <p>
        used in <b>{timesFavouriteLanguageIsUsed}</b> {repositories}
      </p>
    </div>
  )
}

export default Favourites;
