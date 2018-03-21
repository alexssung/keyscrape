import React from 'react'
import KeywordScrapeItem from './KeywordScrapeItem'

export default class KeywordScrapeList extends React.Component {
  render() {
    return (
      <div>
        {this.props.items.map(item => (<KeywordScrapeItem key={item.id} item={item}/>))}
      </div>
    )
  }
}