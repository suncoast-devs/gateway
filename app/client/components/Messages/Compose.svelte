<script>
  import Icon from '../Icon'
  import { post } from '../../utils/api-fetch'

  export let person = {}
  export let lastSubject

  $: prefilledSubject = lastSubject ? regarding(lastSubject) : ''

  let isSMS = false
  let subject = ''
  let body = ''
  let selectedTemplate = null
  let templates = [
    {
      id: 1,
      media: 'email',
      name: 'Blah',
      subject: 'Blah Email',
      body: 'blah blah',
    },
    {
      id: 2,
      media: 'sms',
      name: 'LOL',
      body: 'LOL...',
    },
  ]

  function handleTemplateChange() {
    if (selectedTemplate) {
      body = selectedTemplate.body
      if (selectedTemplate.media === 'email') {
        subject = selectedTemplate.subject
        isSMS = false
      } else {
        isSMS = true
      }
    } else {
      subject = ''
      body = ''
    }
  }

  async function handleSubmit() {
    subject = subject || prefilledSubject
    const { data: ok } = await post('/communications', {
      personId: person.id,
      isSMS,
      subject,
      body,
    })
    if (ok) {
      selectedTemplate = null
      body = ''
    }
  }

  function regarding(quotedSubject) {
    if (/(Re|FWD): ?/i.test(quotedSubject)) {
      return quotedSubject
    } else {
      return `Re: ${quotedSubject}`
    }
  }
</script>

<div class="p-4 pt-2 bg-gray-200 border-t border-gray-300">
  <form on:submit|preventDefault={handleSubmit}>
    <div class="mb-2 flex items-center">
      <button
        on:click|preventDefault={() => (isSMS = !isSMS)}
        class={`transition duration-100 ease-in-out ${isSMS ? 'text-green-600 active:text-green-700' : 'text-gray-600 active:text-gray-700'}`}>
        <Icon name="sms" />
      </button>
      <span class="flex-1" />
      <span class="text-gray-400 text-xs">{person.email}</span>
      <div class="ml-4 w-64 rounded-md">
        <input
          class="py-1 px-2 form-input block w-full transition duration-150 ease-in-out text-sm leading-2 disabled:opacity-50 text-gray-600"
          disabled={isSMS}
          on:change={(e) => (subject = e.target.value)}
          value={isSMS ? '' : subject || prefilledSubject}
          placeholder="Subject" />
      </div>
      <label
        class="mx-2 text-xs text-gray-400 uppercase"
        for="template">Templates</label>
      <select
        id="template"
        class="py-1 form-select block border-gray-300 focus:outline-none focus:shadow-outline-blue focus:border-blue-300 text-sm leading-2"
        bind:value={selectedTemplate}
        on:change={(e) => e.target.blur()}
        on:blur={handleTemplateChange}>
        <option value={null} />
        {#each templates as template (template.id)}
          <option value={template}>{template.name}</option>
        {/each}
      </select>
    </div>
    <div class="flex rounded-md shadow-sm">
      <textarea
        bind:value={body}
        rows="3"
        class="form-textarea block w-full transition duration-150 ease-in-out" />
    </div>
    <div class="mt-2">
      <span class="inline-flex rounded-md shadow-sm">
        <button
          type="submit"
          disabled={body.length < 8}
          class="inline-flex items-center px-2.5 py-1.5 border border-transparent text-xs leading-4 font-medium rounded text-white bg-indigo-600 hover:bg-indigo-500 focus:outline-none focus:border-indigo-700 focus:shadow-outline-indigo active:bg-indigo-700 transition ease-in-out duration-150 disabled:opacity-50">
          Send Message
        </button>
      </span>
    </div>
  </form>
</div>
