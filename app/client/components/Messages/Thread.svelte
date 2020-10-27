<script>
  import Toggle from '../Toggle'
  import Icon from '../Icon'
  import Message from './Message'
  import Messages from '../../pages/Messages.svelte'
  import App from '../../App.svelte'
  import Dashboard from '../../pages/Dashboard.svelte'

  const messages = [
    {
      id: 1,
      subject: 'Your student enrollment agreement',
      body:
        '<p>As requested, here\'s a link to to sign your <a href="#sea">enrollment agreement</a>.</p>',
      isOwn: true,
      media: 'email',
      time: '2020-10-26T09:22:39.972Z',
    },
    {
      id: 2,
      body: '<p>Thanks!</p>',
      subject: 'Re: Your student enrollment agreement',
      media: 'email',
      isOwn: false,
      time: '2020-10-27T12:56:41.972Z',
    },
    {
      id: 3,
      body: '<p>Hello</p>',
      media: 'sms',
      isOwn: true,
      time: '2020-10-28T12:56:41.972Z',
    },
    {
      id: 4,
      body: '<p>Hey</p>',
      media: 'sms',
      isOwn: false,
      time: '2020-10-28T13:22:39.972Z',
    },
  ]
</script>

<div class="p-2 flex-1 flex flex-col overflow-y-auto">
  <h3 class="my-2 mb-6 font-serif text-center italic">
    Conversation with
    <strong>Joe Student</strong>
  </h3>
  {#each messages as message}
    <Message {...message} />
  {/each}
</div>
<div class="p-4 pt-2 bg-gray-200 border-t border-gray-300">
  <div class="mb-2 flex items-center">
    <button class="text-gray-400 hover:text-green-400 active:text-green-600">
      <Icon name="sms" />
    </button>

    <span class="flex-1" />
    <label class="mr-2 text-xs text-gray-400 uppercase" for="">Templates</label>
    <select
      id="location"
      class="py-1 form-select block border-gray-300 focus:outline-none focus:shadow-outline-blue focus:border-blue-300 text-xs leading-1">
      <option selected />
      <option>USA</option>
      <option>Canada</option>
      <option>EU</option>
    </select>
  </div>
  <div class="flex rounded-md shadow-sm">
    <textarea
      rows="3"
      class="form-textarea block w-full transition duration-150 ease-in-out" />
  </div>
  <div class="mt-2">
    <span class="inline-flex rounded-md shadow-sm">
      <button
        type="button"
        class="inline-flex items-center px-2.5 py-1.5 border border-transparent text-xs leading-4 font-medium rounded text-white bg-indigo-600 hover:bg-indigo-500 focus:outline-none focus:border-indigo-700 focus:shadow-outline-indigo active:bg-indigo-700 transition ease-in-out duration-150">
        Send Message
      </button>
    </span>
  </div>
</div>
