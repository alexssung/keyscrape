import React from 'react'

export default class KeywordScrapeForm extends React.Component {
  render() {
    const formStyle = {
      margin: "20px"
    }
    
    return (
      <form className="col-md-12" style={formStyle}>
        <h4>New Keyword Scrape</h4>
        <div className="form-group row">
          <div className="col-md-6">
            <label htmlFor="keywords">Keywords (comma separated)</label>
            <textarea className="form-control" id="keywords" rows="1"></textarea>
          </div>
          <div className="col-md-6">
            <label htmlFor="urls-csv">CSV of URLs (one per line)</label>
            <input type="file" className="form-control-file" id="urls-csv"/>
          </div>
        </div>
        <button type="submit" className="btn btn-primary">Submit</button>
      </form>
    )
  }
}