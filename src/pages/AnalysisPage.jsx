import PageHeader from '../components/PageHeader.jsx'
import SectionCard from '../components/SectionCard.jsx'
import { diseasePredictions } from '../data/mockData.js'

function AnalysisPage() {
  return (
    <div className="page-stack">
      <PageHeader
        title="Scalp analysis results"
        description="Explainable AI predictions generated from scalp imaging and sensor history."
        action={<button className="primary-button">Run new analysis</button>}
      />

      <div className="content-grid">
        {diseasePredictions.map((prediction) => (
          <SectionCard
            key={prediction.condition}
            title={prediction.condition}
            subtitle={`Confidence score: ${prediction.confidence}`}
          >
            <div className="prediction-card">
              <span className="badge badge-neutral">{prediction.severity}</span>
              <p>{prediction.recommendation}</p>
            </div>
          </SectionCard>
        ))}
      </div>
    </div>
  )
}

export default AnalysisPage
