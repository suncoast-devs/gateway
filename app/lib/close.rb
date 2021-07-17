# frozen_string_literal: true
module Close
  OPPORTUNITY_STATUSES = {
    prospecting: 'stat_OOgm0jrlEm2mqrWucE3PDZ7C1l3hlflP7Fw7XqHwYV5',
    applied: 'stat_rB8EiNbRIV70Nc3SO3HRaLLdOFJHJeTQufYmxIYuktj',
    interviewing: 'stat_B9abaIrzJiyscia4qjqj7QEz5f1YntugaqpsDNAQEtT',
    accepted: 'stat_7F9vBDgfjSnpvOJNhkTnDBRNXUVwWPoeQSahXnnbCyD',
    enrolling: 'stat_gPRErfel5Kb0eh6LMXovSRGuHKPQo9bVuzdah51cIz0',
    enrolled: 'stat_sPqxIBPp8iplX0wLWjDAKNDw4du3IHVJaqRWk6Z4WVJ',
    graduated: 'stat_sgvt84qvFlAAJGe7sm7qukt9fycaFwNMI0US2R4cpMo',
    incomplete: 'stat_Il2ePXCsoURAP3phsSy0rxHjwDXNtwFzoyw5sqKyFNs',
    dropped: 'stat_Of1fg7jVkduVy9ZMDhsMUS38UnDzZPUSTowLM63T0jd',
    rejected: 'stat_ng9HsAA2q0A3F8sqaBSmWsKFmRIxFD9aDbyypwQpXyp',
    canceled: 'stat_6fvDD2ISHy6w3kzxVB3NM0UKbiVJikBn1yt40HkUaok',
  }.with_indifferent_access.freeze

  LEAD_STATUS = {
    potential: 'stat_6IUBThmVFaUiEyTFW7gBYHtMjJgb5ySjRGwZfeupLEF',
    interested: 'stat_y3sOe1xIkYbxorAI3vlBdbHtKHHZiFj5AiFrXJCAjk4',
    qualified: 'stat_qYgHF9vQEiGg4PNEaFTDIVTz3yDpWcrUk3hD4ERQpyZ',
    bad_fit: 'stat_1s0UWUp7U3NO1Mo6YqoNjVHDcw5jMNsQnUD7bxxxxv0',
    customer: 'stat_5d0G6jkwBM0e1UmqXkI3FRrFKv40g24xM5ZKN89xrC8',
    canceled: 'stat_jHSETcjN10b4jp97qqLQ5eZzuVBNHSRFL0z28QmfAiJ',
    uninterested: 'stat_31t9JRMiyi7GIO2iFxcMJO9juOaQfJmInvRHPyGRfNp',
    irrelevant: 'stat_2HUng0VSz8ncGDSdJe73I8vJyKhhH6GFcHoMeOEx1ZL',
  }.with_indifferent_access.freeze

  COHORT_FIELD = 'lcf_C6wG4HgXpRWz455SDezi3eHiNNaRMdtyRUfGoO5aZIZ'
  GATEWAY_FIELD = 'lcf_GD5hdf9Z4k5poQVTw7wrbRe1ogeZgDxFJwxFjG6II1g'
end
