#!/bin/sh

bundle exec ./trello create_labels
bundle exec ./trello sync_labels
bundle exec ./trello convert_markers_to_labels
bundle exec ./trello update --update-roadmap