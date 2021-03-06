//
//  FootballSPFCell.swift
//  彩小蜜
//
//  Created by HX on 2018/3/30.
//  Copyright © 2018年 韩笑. All rights reserved.
//  胜平负

import UIKit

let typeIconSize : CGFloat = 24

protocol FootballSPFCellDelegate {
    func didTipSPFCellDetail(teamInfo : FootballPlayListModel) -> Void
    func didTipStopSelling(cell: FootballSPFCell, teamInfo : FootballPlayListModel) -> Void
}

class FootballSPFCell: UITableViewCell, DateProtocol, FootballStopSellingViewDelegate {
    
    

    public var playInfoModel: FootballPlayListModel! {
        didSet{
            guard playInfoModel != nil else { return }
            changSellingState(isStop: playInfoModel.isShutDown )
            
            matchTitle.text = playInfoModel.leagueAddr
            matchTime.text = playInfoModel.changci
            teamView.teamInfo = playInfoModel
            endTime.text = "截止" + timeStampToHHmm(playInfoModel.betEndTime)
            if playInfoModel.matchPlays[0].single == true {
                typeIcon.isHidden = false
            }else {
                typeIcon.isHidden = true
            }
        }
    }
    
    public var delegate : FootballSPFCellDelegate!
    
    private var matchTitle: UILabel!
    private var matchTime: UILabel!
    private var endTime: UILabel!
    private var detailBut: UIButton!
    public var teamView: FootballTeamView!
    // 单关图标
    private var typeIcon : UIImageView!
    
    private var line : UIImageView!
    
    private var stopSellingView: FootballStopSellingView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubview()
    }

    private func changSellingState(isStop: Bool) {
        if isStop {
            teamView.alpha = 0.2
            stopSellingView.isHidden = false
        }else {
            teamView.alpha = 1
            stopSellingView.isHidden = true
        }
    }
    
    func didTipDetails(view: UIView) {
        guard delegate != nil else { return }
        delegate.didTipStopSelling(cell: self, teamInfo: self.playInfoModel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        line.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.left.equalTo(leftSpacing)
            make.right.equalTo(-rightSpacing)
            make.height.equalTo(1)
        }

        typeIcon.snp.makeConstraints { (make) in
            make.top.left.equalTo(0)
            make.width.height.equalTo(typeIconSize * defaultScale)
        }

        matchTitle.snp.makeConstraints { (make) in
            make.top.equalTo(13.5 * defaultScale)
            make.left.equalTo(10 * defaultScale)
            make.width.height.equalTo(endTime)
        }
        matchTime.snp.makeConstraints { (make) in
            make.top.equalTo(matchTitle.snp.bottom).offset(2)
            make.left.width.height.equalTo(endTime)
        }
        endTime.snp.makeConstraints { (make) in
            make.left.equalTo(matchTitle)
            make.top.equalTo(matchTime.snp.bottom).offset(2)
            make.bottom.equalTo(detailBut.snp.top).offset(-2)
            make.width.equalTo(70 * defaultScale)
        }
        detailBut.snp.makeConstraints { (make) in
            make.centerX.equalTo(endTime.snp.centerX)
            make.top.equalTo(endTime.snp.bottom)
            make.width.equalTo(endTime)
            make.bottom.equalTo(-1)
        }
        teamView.snp.makeConstraints { (make) in
            make.top.equalTo(15 * defaultScale)
            make.bottom.equalTo(-15 * defaultScale)
            make.right.equalTo(-rightSpacing)
            make.left.equalTo(endTime.snp.right).offset(10 * defaultScale)
        }
        stopSellingView.snp.makeConstraints { (make) in
            make.top.equalTo(teamView)
            make.bottom.equalTo(teamView)
            make.left.equalTo(teamView)
            make.right.equalTo(teamView)
        }
    }
    private func initSubview() {
        self.selectionStyle = .none
        
        line = UIImageView()
        line.image = UIImage(named: "line")
        
        teamView = FootballTeamView()
        
        typeIcon = UIImageView()
        typeIcon.image = UIImage(named: "Singlefield")
        
        matchTitle = initLabel()
        
        matchTime = initLabel()
        
        endTime = initLabel()
        endTime.sizeToFit()
        
        detailBut = UIButton(type: .custom)
        detailBut.setImage(UIImage(named: "Collapse"), for: .normal)
        detailBut.titleLabel?.numberOfLines = 2
        detailBut.contentEdgeInsets = UIEdgeInsets(top: 2, left: 0, bottom: 5, right: 0)
        detailBut.addTarget(self, action: #selector(detailButClicked(_:)), for: .touchUpInside)
        
        stopSellingView = FootballStopSellingView()
        stopSellingView.delegate = self 
        stopSellingView.vertical = true 
        
        self.contentView.addSubview(line)
        self.contentView.addSubview(teamView)
        self.contentView.addSubview(typeIcon)
        self.contentView.addSubview(matchTitle)
        self.contentView.addSubview(matchTime)
        self.contentView.addSubview(endTime)
        self.contentView.addSubview(detailBut)
        self.contentView.addSubview(stopSellingView)
    }
    private func initLabel() -> UILabel {
        let lab = UILabel()
        lab.font = Font12
        lab.textColor = Color787878
        lab.textAlignment = .center
        //lab.text = "截止23： 50"
        return lab
    }
    
    @objc private func detailButClicked(_ sender : UIButton ) {
        guard delegate != nil else { return }
        delegate.didTipSPFCellDetail(teamInfo: self.playInfoModel)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
