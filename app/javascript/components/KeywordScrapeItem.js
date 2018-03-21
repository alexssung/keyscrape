import React from 'react'

export default class KeywordScrapeItem extends React.Component {
  render() {
    return (
      <div>{this.props.item.keywords.join(", ")}</div>
    )
  }
}