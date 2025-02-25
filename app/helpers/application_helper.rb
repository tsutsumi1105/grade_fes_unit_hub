module ApplicationHelper
  def default_meta_tags
    {
      site: 'Grade Fes Unit Hub',
      description: 'グレフェス編成紹介サイト',
      keywords: 'グレフェス',
      og: {
        site_name: 'Grade Fes Unit Hub',
        title: 'Grade Fes Unit Hub',
        description: 'グレフェス編成紹介サイト',
        image: asset_url('ogp.png'),
        url: request.original_url,
        type: 'website'
      },
      twitter: {
        card: 'summary_large_image',
        title: 'Grade Fes Unit Hub',
        description: 'グレフェス編成紹介サイト',
        image: asset_url('ogp.png')
      }
    }
  end
end