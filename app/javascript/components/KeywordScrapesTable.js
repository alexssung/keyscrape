import React from 'react'
import KeywordScrapeRow from './KeywordScrapeRow'

export default class KeywordScrapesTable extends React.Component {
  render() {
    return (
      <table className="table table-striped">
        <thead>
          <tr>
            <th>Date</th>
            <th>Keywords</th>
            <th>Status</th>
            <th></th>
          </tr>
        </thead>
        <tbody>
          {this.props.items.map(item => (<KeywordScrapeRow key={item.id} item={item}/>))}
        </tbody>
      </table>
    )
  }
}