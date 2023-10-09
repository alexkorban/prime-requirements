window.onload = append_fn window.onload, ->
  module "EditableEntity - simple functions"

  test "?.", ->
    bla = null
    equals(bla?.moo or 3, 3)

  test "form id", ->
    equals(new EditableEntity({entity: "test", fields: ["id", "name"]}).form_id(), "#test_form")

  test "base_url", ->
    equals(new EditableEntity({entity: "test", fields: ["id", "name"]}).base_url(), "/tests")
    equals(new EditableEntity({entity: "test", fields: ["id", "name"], url: "custom_url"}).base_url(), "custom_url")

  test "get_nested_table_name", ->
    equals(new EditableEntity({entity: "test", fields: ["id", "name", {"nested_attributes": ["id", "name"]}]}).get_nested_table_name(), "nested")

  module "EditableEntity - not so simple functions"

  test "has_nested_items", ->
    equals(new EditableEntity({entity: "test", fields: ["id", "name"]}).can_have_nested_items(), false)                      
    equals(new EditableEntity({entity: "test", fields: ["id", "name", {"nested_attributes": ["id", "name"]}]}).can_have_nested_items(), true)

  test "get_data", ->
    d = {id: 4, name: "bla"}
    same(new EditableEntity({entity: "test", fields: ["id", "name"], data: {test: d}}).get_data(4), d)
    d2 = {id: 8, name: "moo"}
    same(new EditableEntity({entity: "test", fields: ["id", "name"], data: [{test: d}, {test: d2}]}).get_data(8), d2)

  test "get_data", ->
    d = {id: 4, name: "bla"}
    same(new EditableEntity({entity: "test", fields: ["id", "name"], data: {test: d}}).get_data(4), d)
    d2 = {id: 8, name: "moo"}
    same(new EditableEntity({entity: "test", fields: ["id", "name"], data: [{test: d}, {test: d2}]}).get_data(8), d2)

  test "get_nested_item_count", ->
    equals(new EditableEntity({entity: "test", fields: ["id", "name", {"nested_attributes": ["id", "name"]}]}).
      nested_item_count(null), 3)
    equals(new EditableEntity({entity: "test", fields: ["id", "name", {"nested_attributes": ["id", "name"]}]}).
      nested_item_count({id: 1, name: "moo"}), 3)
    equals(new EditableEntity({entity: "test", fields: ["id", "name", {"nested_attributes": ["id", "name"]}]}).
      nested_item_count({id: 1, name: "moo", nested: [{"id": 1}, {"id": 2}]}), 2)

  test "update_data", ->
    d = {id: 1, name: "foo", nested: [{"id": 1}, {"id": 2}]} 
    same(new EditableEntity({entity: "test", fields: ["id", "name", {"nested_attributes": ["id", "name"]}],
      data: {"test": {id: 1, name: "moo", nested: [{"id": 1}, {"id": 2}]}}}).
      update_data(d), d)

    d2 = {id: 2, name: "boohoo"}
    same(new EditableEntity({entity: "test", fields: ["id", "name", {"nested_attributes": ["id", "name"]}],
      data: [{"test":{id: 1, name: "moo", nested: [{"id": 1}, {"id": 2}]}}, {"test":{id: 2, name: "boo"}}]}).
      update_data(d2), [{"test":{id: 1, name: "moo", nested: [{"id": 1}, {"id": 2}]}}, {"test":{id: 2, name: "boohoo"}}])      