namespace :ac do
  task sync: :environment do
    tags = {}

    ActiveCampaign.get("tags")["tags"].each do |tag|
      tags[tag["tag"]] = tag["id"]
    end

    Tag.all.each do |tag|
      unless tags[tag.name]
        ac_tag = ActiveCampaign.post("tags", {
          tag: {
            tag: tag.name,
            tagType: "contact",
          },
        })["tag"]
        tags[ac_tag["tag"]] = ac_tag["id"]
      end
    end

    Person.all.each do |person|
      person.tags.each do |tag|
        ActiveCampaign.post("contactTags", {
          contactTag: {
            contact: person.ac_contact_identifier,
            tag: tags[tag.name],
          },
        })
      end
    end
  end
end
