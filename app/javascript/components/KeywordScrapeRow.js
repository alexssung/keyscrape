import React from 'react'

export default class KeywordScrapeRow extends React.Component {
  render() {
    return (
      <tr>
        <td>{new Date(this.props.item.created_at).toLocaleString('en-US')}</td>
        <td>{this.props.item.keywords.join(", ")}</td>
        <td>{this.props.item["complete?"] ? "complete" : "scraping..."}</td>
        <td>
          { this.props.item["complete?"] &&
            <a href={`/api/keyword_scrapes/${this.props.item.id}/download`}>Download Report</a>
          }
        </td>
      </tr>
    )
  }
}