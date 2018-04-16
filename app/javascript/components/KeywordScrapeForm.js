import React from 'react'
import axios from 'axios'

export default class KeywordScrapeForm extends React.Component {
  constructor(props){
    super(props);
    this.submitForm = this.submitForm.bind(this)
  }
  
  submitForm(e) {
    e.preventDefault();
    let form_data = new FormData();
    let csv_file = document.querySelector('#csv-file');
    let keywords = document.querySelector('#keywords');
    form_data.append('csv_file', csv_file.files[0]);
    form_data.append('keywords', keywords.value);
    axios.post('/api/keyword_scrapes', form_data, {
      headers: {
        'X-CSRF-TOKEN' : document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      }
    })
      .then(response => {
        this.props.refreshKeywordScrapes();
      })
      .catch(response => {
        alert(JSON.stringify(response));
      })
  }
  
  render() {
    const formStyle = {
      margin: "20px"
    }
    
    return (
      <form className="col-md-12" onSubmit={this.submitForm} style={formStyle}>
        <h4>New Keyword Scrape</h4>
        <div className="form-group row">
          <div className="col-md-6">
            <label htmlFor="keywords">Keywords (comma separated)</label>
            <textarea className="form-control" id="keywords" rows="1"></textarea>
          </div>
          <div className="col-md-6">
            <label htmlFor="urls-csv">CSV of URLs (one per line)</label>
            <input type="file" className="form-control-file" id="csv-file"/>
          </div>
        </div>
        <button type="submit" className="btn btn-primary">Submit</button>
      </form>
    )
  }
}