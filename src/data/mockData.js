export const navigationItems = [
  { to: '/dashboard', label: 'Dashboard' },
  { to: '/patients', label: 'Patients' },
  { to: '/analysis', label: 'Scalp Analysis' },
  { to: '/monitoring', label: 'IoT Monitoring' },
  { to: '/reports', label: 'Reports' },
  { to: '/profile', label: 'Profile' },
]

export const overviewStats = [
  { label: 'Active Patients', value: '1,248', change: '+12% this month' },
  { label: 'AI Screenings', value: '326', change: '+28 new today' },
  { label: 'Critical Alerts', value: '08', change: '3 need review now' },
  { label: 'Connected Devices', value: '54', change: '98.7% uptime' },
]

export const patientSummaries = [
  {
    id: 'TG-1045',
    name: 'Amara Bello',
    age: 29,
    risk: 'Moderate',
    lastVisit: '2026-07-10',
    focus: 'Dry scalp and mild inflammation',
  },
  {
    id: 'TG-1031',
    name: 'Khalid Noor',
    age: 34,
    risk: 'High',
    lastVisit: '2026-07-09',
    focus: 'Rapid shedding and irritated follicles',
  },
  {
    id: 'TG-1022',
    name: 'Zainab Okeke',
    age: 41,
    risk: 'Low',
    lastVisit: '2026-07-08',
    focus: 'Recovery after antifungal treatment',
  },
]

export const sensorMetrics = [
  {
    name: 'Scalp Temperature',
    value: '36.8°C',
    status: 'Stable',
    insight: 'Within healthy dermatology range',
  },
  {
    name: 'Moisture Index',
    value: '61%',
    status: 'Watch',
    insight: 'Hydration trending below personal baseline',
  },
  {
    name: 'pH Balance',
    value: '5.4',
    status: 'Optimal',
    insight: 'Balanced acidity for healthy scalp barrier',
  },
]

export const diseasePredictions = [
  {
    condition: 'Seborrheic Dermatitis',
    confidence: '92%',
    severity: 'Moderate',
    recommendation: 'Introduce medicated wash cycle and schedule follow-up imaging.',
  },
  {
    condition: 'Alopecia Areata',
    confidence: '81%',
    severity: 'Watchlist',
    recommendation: 'Flag for dermatologist review and compare with shedding history.',
  },
  {
    condition: 'Folliculitis',
    confidence: '74%',
    severity: 'Low',
    recommendation: 'Maintain cleansing protocol and continue sensor observation.',
  },
]

export const reportHighlights = [
  {
    title: 'Weekly Clinical Summary',
    detail: 'AI identified 17 rising-risk cases requiring triage within 48 hours.',
  },
  {
    title: 'Device Compliance',
    detail: '91% of enrolled wearables uploaded a complete seven-day telemetry set.',
  },
  {
    title: 'Therapy Response',
    detail: 'Moisture normalization improved by 14% after personalized regimen updates.',
  },
]

export const appointments = [
  { patient: 'Amara Bello', time: '09:30', type: 'Sensor calibration' },
  { patient: 'Khalid Noor', time: '11:00', type: 'AI review consult' },
  { patient: 'Zainab Okeke', time: '14:15', type: 'Progress follow-up' },
]
