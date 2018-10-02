IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AspNetUsers]') AND type in (N'U'))
begin
insert into AspNetRoles values(7, 'SuperUser');
update AspNetUserRoles set roleid=7 where UserId in ('1461e80d-339b-4cb6-9cb4-a0575c3b903f','abd258a0-769c-4e62-9ec0-3e1211ddccfc');
end