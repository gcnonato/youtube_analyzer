class YoutubeAnalyzersController < ApplicationController

  require 'uri'
  require 'net/http'
  CLIENT_ID     = Settings.youtube_analytics_client_id
  CLIENT_SECRET = Settings.youtube_analytics_client_secret
  REDIRECT_URI  = 'http://localhost:3000/youtube_analyzers/oauth2callback'
  SCOPE         = 'https://www.googleapis.com/auth/yt-analytics.readonly'
  AUTH_TARGET   = 'https://accounts.google.com/o/oauth2/auth'
  POST_TARGET   = 'https://accounts.google.com/o/oauth2/token'
  GET_TARGET    = 'https://www.googleapis.com/youtube/analytics/v1/reports'
  #CHANNEL_ID    = 'UClll215OOauqh91v2n-v5hA'
  CHANNEL_ID    = 'UCDLe_iX8dWkR8U_bvajGD8Q'
  METRICS       = 'views,comments,favoritesAdded,likes,dislikes,estimatedMinutesWatched,averageViewDuration,averageViewPercentage'
  START_DATE    = '2015-04-01'
  END_DATE      = '2015-12-31'

  def index
    redirect_to "#{AUTH_TARGET}?client_id=#{CLIENT_ID}&redirect_uri=#{REDIRECT_URI}&scope=#{SCOPE}&response_type=code"
  end

  def oauth2callback
    @code = params[:code]
    @js_res = ''

    uri = URI.parse(POST_TARGET)
    data = "code=#{@code}&client_id=#{CLIENT_ID}&client_secret=#{CLIENT_SECRET}&redirect_uri=#{REDIRECT_URI}&grant_type=authorization_code"

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl =true
    http.start do |h|
      @res = h.post(uri.path, data)
      @js_res = JSON.parse(@res.body)
      puts @res.body
    end

    get_uri = URI.parse(GET_TARGET)
    auth = "Bearer #{@js_res['access_token']}"
    puts auth

    # 動画単位の集計（上位10件）
    get_path = "/youtube/analytics/v1/reports?ids=channel==#{CHANNEL_ID}&start-date=#{START_DATE}&end-date=#{END_DATE}&metrics=#{METRICS}&dimensions=day&sort=-day"
    # 日単位の集計
    #get_path = "/youtube/analytics/v1/reports?ids=channel==#{CHANNEL_ID}&start-date=#{START_DATE}&end-date=#{END_DATE}&metrics=#{METRICS}&dimensions=day&sort=day"
    ht = Net::HTTP.new(get_uri.host, get_uri.port)
    ht.use_ssl =true
    ht.start do |h|
      get_res = h.get(get_path, header={"Authorization" => auth})
      js_get_res = JSON.parse(get_res.body)
      puts @response = js_get_res
      puts @response['rows'].class
    end

  end

end
