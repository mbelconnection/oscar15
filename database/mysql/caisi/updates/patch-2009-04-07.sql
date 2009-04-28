alter table intake_node add form_type integer default 0;

update intake_node set form_type =1 where intake_node_id=1;

update intake_node set form_type=2 where intake_node_id=2;
update intake_node set publish_by="Annie,Zhou" where intake_node_id=2;
update intake_node set intake_node_label_id=3 where intake_node_id=2;
update intake_node set form_version=1 where intake_node_id=2;
update intake_node set publish_date="2009-04-21" where intake_node_id=2;
