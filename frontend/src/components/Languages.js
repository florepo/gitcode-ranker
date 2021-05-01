import React from 'react';

const Languages = () => {
  const languages = Object.keys(this.props.data["languages"]).filter(Boolean).sort()

  let numberOfTimesUsed = (language) => this.props.data["languages"][language]
  let pluralizeRepositoryFor = (language) => numberOfTimesUsed (language)===1 ? "repository" : "repositories"

  return (
    <div className="favourites">     
      {
        languages
        ?
        languages.map(language =>
          <div key={language}>
            <p className="language-list">
              <b>{language}</b> is used in <b> {numberOfTimesUsed(language)}</b> {pluralizeRepositoryFor(language)}
            </p>
          </div>
        )
        :
        null
      }
    </div>
  )
}
 
export default Languages;
