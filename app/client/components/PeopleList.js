import React from 'react'
import {
  Button,
  ButtonGroup,
  ControlGroup,
  Intent,
  InputGroup,
  Menu,
  MenuDivider,
  MenuItem,
  Popover,
  Tag,
} from '@blueprintjs/core'
import { Section } from '.'

const CohortList = () => (
  <Menu>
    <MenuItem icon="tick-circle" intent={Intent.PRIMARY} text="Cohort X" />
    <MenuItem icon="blank" text="Cohort XI" />
    <MenuDivider />
    <MenuItem
      icon="filter-remove"
      intent={Intent.WARNING}
      text="Remove Filter"
    />
  </Menu>
)

export const PeopleList = () => (
  <Section>
    <ControlGroup>
      <InputGroup leftIcon="user" placeholder="Search people&hellip;" />
      <ButtonGroup minimal>
        <Button icon="filter" disabled />
        <Popover content={<CohortList />}>
          <Button
            icon="people"
            rightIcon="caret-down"
            text={
              <span>
                <Tag>X</Tag> <Tag>XI</Tag>
              </span>
            }
          />
        </Popover>
        <Popover content={<CohortList />}>
          <Button
            icon="form"
            rightIcon="caret-down"
            text={<Tag>Applied</Tag>}
          />
        </Popover>
        <Popover content={<CohortList />}>
          <Button icon="flag" rightIcon="caret-down" text={<Tag>Active</Tag>} />
        </Popover>
      </ButtonGroup>
    </ControlGroup>
  </Section>
)
