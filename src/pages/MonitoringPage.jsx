import PageHeader from '../components/PageHeader.jsx'
import SectionCard from '../components/SectionCard.jsx'
import { sensorMetrics } from '../data/mockData.js'

function MonitoringPage() {
  return (
    <div className="page-stack">
      <PageHeader
        title="IoT sensor monitoring"
        description="Watch live wearable readings for scalp temperature, moisture, and pH balance."
        action={<button className="primary-button">Sync devices</button>}
      />

      <div className="content-grid">
        {sensorMetrics.map((metric) => (
          <SectionCard key={metric.name} title={metric.name} subtitle={metric.insight}>
            <div className="sensor-panel">
              <strong className="metric-value">{metric.value}</strong>
              <div className="sensor-bar">
                <span style={{ width: metric.progress }} />
              </div>
              <p>Status: {metric.status}</p>
            </div>
          </SectionCard>
        ))}
      </div>
    </div>
  )
}

export default MonitoringPage
