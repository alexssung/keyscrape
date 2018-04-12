import React from 'react'
import KeywordScrapeForm from 'components/KeywordScrapeForm'
import KeywordScrapesTable from 'components/KeywordScrapesTable'
import axios from 'axios'

export default class Dashboard extends React.Component {
  constructor(props){
    super(props);
    this.state = {
      keyword_scrapes: [],
    };
  }
  
  componentDidMount() {
    axios.get("api/keyword_scrapes")
      .then(response => this.setState({ keyword_scrapes: response.data }));
  }
  
  render() {
    return (
      <div id="dashboard">
        <div className="container">
          <div className="row">
            <KeywordScrapeForm />
          </div>
          <div className="row">
            <KeywordScrapesTable items={this.state.keyword_scrapes}/>
          </div>
        </div>
      </div>
    )
  }
}