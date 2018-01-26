#include <stdio.h>
int nums[1010];
int main(void)
{
    int n,num,r=0,l=0,ans=-1;
    scanf("%d",&n);
    for(int i=0;i<n;i++)
        scanf("%d",&nums[i]);
    for(int i=0;i<n;i++)
    {
        l=0;r=0;
        for(int j=0;j<n;j++)
        {
            if(nums[i]>nums[j])l++;
            if(nums[i]<nums[j])r++;
        }
        if(l==r)
        {
            ans=nums[i];
            break;
        }
    }
    printf("%d",ans);
    return 0;
}

