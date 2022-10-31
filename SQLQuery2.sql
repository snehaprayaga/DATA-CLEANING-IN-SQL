select *
from [Nashville Housing]

--standardize Date format

select SalesDateconverted -- CONVERt(date,saledate)
from [Nashville Housing]

ALTER TABLE [Nashville Housing]
ADD SalesDateConverted Date

Update [Nashville Housing]
SET SalesDateConverted=CONVERt(date,saledate)

--Populate Property address data
select * ---PropertyAddress
from [Nashville Housing]
-- where PropertyAddress IS NULL
ORDER BY ParcelID

Select a.ParcelID, a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress, b.PropertyAddress)
from [Nashville Housing] a join [Nashville Housing] b
on a.ParcelID = b.ParcelID
AND a. [UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is NULL 

update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from [Nashville Housing] a join [Nashville Housing] b
on a.ParcelID = b.ParcelID
AND a. [UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is NULL 

--Breaking out address into individual columns

select PropertyAddress
from [Nashville Housing]
-- where PropertyAddress IS NULL
--oRDER BY ParcelID

SELECT 
SUBSTRING(PropertyAddress,1,CHARINDEX(',' ,PropertyAddress)-1) as address,
SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as addy 
from [Nashville Housing]

ALTER TABLE [Nashville Housing]
ADD PropertySplitAddress VARCHAR(255),
 Property_Split_City VARCHAR(255);

Update [Nashville Housing]
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',' ,PropertyAddress)-1),
Property_Split_City = SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

select *
from [Nashville Housing]

SELECT Owneraddress
from  [Nashville Housing]

select 
PARSENAME(REPLACE(OwnerAddress,',' , '.'),3),
PARSENAME(REPLACE(OwnerAddress,',' , '.'),2),
PARSENAME(REPLACE(OwnerAddress,',' , '.'),1)
from [Nashville Housing] 

ALTER TABLE [Nashville Housing]
ADD OwnerSplitAddress VARCHAR(255),
 OwnerSplitCity VARCHAR(255),
 OwnerSplitState VARCHAR(255);

Update [Nashville Housing]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',' , '.'),3),
OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',' , '.'),2),
OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',' , '.'),1)

select *
from [Nashville Housing]

--change Y and N to Yes and NO in "sOLD AS Vacant"Field

select distinct(SoldAsVacant), count(SoldAsVacant)
from [Nashville Housing]
Group by SoldAsVacant
order by 2

select REPLACE(SoldAsVacant,'Y','Yes'),
REPLACE(SoldAsVacant,'N','No')
from [Nashville Housing]

Select SoldAsVacant,
CASE
when SoldAsVacant='Yeses' THEN 'YES'
when SoldAsVacant='Noo' THEN 'NO'
when SoldAsVacant='Y' THEN 'YES'
when SoldAsVacant='N' THEN 'NO'
ELSE SoldAsVacant
END
FROM [Nashville Housing]

UPDATE [Nashville Housing]
SET SoldAsVacant = CASE
when SoldAsVacant='Yeses' THEN 'YES'
when SoldAsVacant='Noo' THEN 'NO'
when SoldAsVacant='Y' THEN 'YES'
when SoldAsVacant='N' THEN 'NO'
ELSE SoldAsVacant
END
FROM [Nashville Housing]

SELECT DISTINCT(SoldAsVacant),COUNT(SoldAsVacant)
FROM [Nashville Housing]
GROUP BY SoldAsVacant

--rEMOVING DUPLICATES
select *
from [Nashville Housing]


with RowNumCTE AS (
select *,
 ROW_NUMBER() OVER( PARTITION BY ParcelID, PropertyAddress, SalePrice,SaleDate,LegalReference
 ORDER BY UniqueID) row_num
 from [Nashville Housing]
 )
 select * 
from RowNumCTE
where row_num >1

--Delete unused columns
select *
from [Nashville Housing]
Alter Table [Nashville Housing]
DROP column OwnerAddress,TaxDistrict,PropertyAddress,SaleDate