import React from 'react'
import KeywordScrapeForm from 'components/KeywordScrapeForm'
import KeywordScrapeList from 'components/KeywordScrapeList'
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
            <KeywordScrapeList items={this.state.keyword_scrapes}/>
          </div>
        </div>
      </div>
    )
  }
}