import PageHeader from '../components/PageHeader.jsx'
import SectionCard from '../components/SectionCard.jsx'
import { patientSummaries } from '../data/mockData.js'

function PatientsPage() {
  return (
    <div className="page-stack">
      <PageHeader
        title="Patient management"
        description="Review demographics, risks, and care priorities for enrolled patients."
        action={<button className="primary-button">Add patient</button>}
      />

      <SectionCard title="Patient registry" subtitle="Active cases within the Tricho Guard program.">
        <div className="table-card">
          <div className="table-header">
            <span>Patient</span>
            <span>Age</span>
            <span>Risk</span>
            <span>Clinical focus</span>
          </div>
          {patientSummaries.map((patient) => (
            <div key={patient.id} className="table-row">
              <div>
                <strong>{patient.name}</strong>
                <p>{patient.id}</p>
              </div>
              <span>{patient.age}</span>
              <span className={`badge badge-${patient.risk.toLowerCase()}`}>{patient.risk}</span>
              <span>{patient.focus}</span>
            </div>
          ))}
        </div>
      </SectionCard>
    </div>
  )
}

export default PatientsPage
