require 'aws-sdk-dynamodb'
require 'json'

TABLE = ENV['table']

def handler(event:, context:)
  name = event['name']
  client = Aws::DynamoDB::Client.new
  result = client.get_item({
    table_name: TABLE,
    key: {
      'name': name,
    },
  })

  save(client, name)
  responce = {
    status: :ok,
    name: name,
  }    
  if result.item.nil?
    # first time
    return responce
  else
    return responce.merge!({ last: result.item['last'] })
  end
end

def save(client, name)
  now = Time.now.strftime('%s')
  client.put_item({
    table_name: TABLE,
    item: {
      'name': name,
      'last': now,
    },
  })
end
