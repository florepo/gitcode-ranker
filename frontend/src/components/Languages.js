import React from 'react';

const Languages = (props) => {
  const sortByValue= (hash) => Object.keys(hash).sort(function(a,b){return hash[a]-hash[b]}).reverse()
  const rankedLanguages = sortByValue(props.data["languages"]).filter(Boolean)

  let numberOfTimesUsed = (language) => props.data["languages"][language]
  let pluralizeRepositoryFor = (language) => numberOfTimesUsed(language)===1 ? "repository" : "repositories"

  let renderElements

  if (rankedLanguages.length===0){
    renderElements = null
  } else {
    renderElements =
    <React.Fragment>
      <p>Breakdown of languages used in repositories:</p>
      {rankedLanguages.map(language =>
        <div key={language}>
          <p className="language-list-item">
            <b>{language}</b> in <b> {numberOfTimesUsed(language)}</b> {pluralizeRepositoryFor(language)}
          </p>
        </div>
      )}
    </React.Fragment>
  }

  return (
    <div className="language-list">
      {renderElements}
    </div>
  )
}
 
export default Languages;
