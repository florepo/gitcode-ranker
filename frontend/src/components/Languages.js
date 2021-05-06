import React from 'react';

const Languages = (props) => {
  const sortByValue= (hash) => Object.keys(hash).sort(function(a,b){return hash[a]-hash[b]}).reverse()
  const rankedLanguages = sortByValue(props.data["languages"]).filter(Boolean)

  let numberOfTimesUsed = (language) => props.data["languages"][language]
  let pluralizeRepositoryFor = (language) => numberOfTimesUsed(language)===1 ? "repository" : "repositories"

  return (
    <div className="language-list">
      <p>Breakdown of repository's main languages:</p>
      {rankedLanguages.map(language =>
        <div key={language}>
          <p className="language-list-item">
            <b>{language}</b> in <b> {numberOfTimesUsed(language)}</b> {pluralizeRepositoryFor(language)}
          </p>
        </div>
      )}
    </div>
  )
}
 
export default Languages;
