import PageHeader from '../components/PageHeader.jsx'
import SectionCard from '../components/SectionCard.jsx'
import StatCard from '../components/StatCard.jsx'
import { appointments, overviewStats, patientSummaries, sensorMetrics } from '../data/mockData.js'

function DashboardPage() {
  return (
    <div className="page-stack">
      <PageHeader
        title="Clinical dashboard"
        description="Track patients, AI risk signals, and wearable scalp telemetry in a single view."
        action={<button className="primary-button">Export snapshot</button>}
      />

      <div className="stats-grid">
        {overviewStats.map((item) => (
          <StatCard key={item.label} {...item} />
        ))}
      </div>

      <div className="content-grid">
        <SectionCard
          title="Priority patients"
          subtitle="Latest cases that require care team attention."
        >
          <div className="list-grid">
            {patientSummaries.map((patient) => (
              <article key={patient.id} className="info-card">
                <div className="info-row">
                  <strong>{patient.name}</strong>
                  <span className={`badge badge-${patient.risk.toLowerCase()}`}>{patient.risk}</span>
                </div>
                <p>{patient.focus}</p>
                <small>
                  {patient.id} • Last visit {patient.lastVisit}
                </small>
              </article>
            ))}
          </div>
        </SectionCard>

        <SectionCard title="Sensor snapshot" subtitle="Current biometric scalp environment readings.">
          <div className="list-grid">
            {sensorMetrics.map((metric) => (
              <article key={metric.name} className="info-card">
                <div className="info-row">
                  <strong>{metric.name}</strong>
                  <span className="badge badge-neutral">{metric.status}</span>
                </div>
                <p className="metric-value">{metric.value}</p>
                <small>{metric.insight}</small>
              </article>
            ))}
          </div>
        </SectionCard>
      </div>

      <SectionCard title="Today's schedule" subtitle="Upcoming consultations and monitoring touchpoints.">
        <div className="schedule-list">
          {appointments.map((item) => (
            <div key={`${item.patient}-${item.time}`} className="schedule-item">
              <strong>{item.time}</strong>
              <div>
                <p>{item.patient}</p>
                <span>{item.type}</span>
              </div>
            </div>
          ))}
        </div>
      </SectionCard>
    </div>
  )
}

export default DashboardPage
